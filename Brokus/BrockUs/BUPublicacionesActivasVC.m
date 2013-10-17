//
//  BUPublicacionesActivasVC.m
//  BrockUs
//
//  Created by Nodus12 on 10/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPublicacionesActivasVC.h"
#import "BUAppDelegate.h"
#import "Publicacion.h"
<<<<<<< HEAD
=======
#import "BUConsultaPublicacion.h"
>>>>>>> master
#import "BUConsultaDetallePubVC.h"

@interface BUPublicacionesActivasVC (){
    NSManagedObjectContext *context;
    NSMutableArray *fetchedArray;
}
<<<<<<< HEAD
=======
@property (strong) Persona *userbrockus;
>>>>>>> master

@end

@implementation BUPublicacionesActivasVC

@synthesize pub;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
<<<<<<< HEAD
=======
    BUConsultaPublicacion *cons=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [cons recuperaPersona:userStr :context];
>>>>>>> master
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *consulta = [NSEntityDescription
                                     entityForName:@"Publicacion" inManagedObjectContext:context];
    
<<<<<<< HEAD
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@" status=%i",1];
=======
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toPersona=%@ AND status=1",self.userbrockus];
    NSLog(@"Usuario de consulta: %@",self.userbrockus);
>>>>>>> master
    [request setPredicate:predicate];
    
    
    [request setEntity:consulta];
    
    
    fetchedArray = [[context executeFetchRequest:request error:&error]mutableCopy];
    
}
-(void)viewDidAppear:(BOOL)animated{
<<<<<<< HEAD
    [self.tableView reloadData];
}
=======
    [self reloadTable];
}

>>>>>>> master
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadTable{
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *consulta = [NSEntityDescription
                                     entityForName:@"Publicacion" inManagedObjectContext:context];
    
<<<<<<< HEAD
=======
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toPersona= %@ AND status=1",self.userbrockus];
    [request setPredicate:predicate];
    
>>>>>>> master
    [request setEntity:consulta];
    
    
    fetchedArray = [[context executeFetchRequest:request error:&error]mutableCopy];
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int rows=[fetchedArray count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
<<<<<<< HEAD
    Publicacion *pub=[fetchedArray objectAtIndex:indexPath.row];
    NSString *publicacion=pub.titulo;
    cell.textLabel.text = publicacion;
=======
    Publicacion *publicacion=[fetchedArray objectAtIndex:indexPath.row];
    NSString *titulo=publicacion.titulo;
    cell.textLabel.text = titulo;
>>>>>>> master
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
<<<<<<< HEAD

        pub=[fetchedArray objectAtIndex:indexPath.row];
        pub.status=0;
        NSLog(@"publicacion inactiva: %@",pub);
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Error al desactivar publicacion; %@ %@", error, [error localizedDescription]);
        }
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [fetchedArray removeObjectAtIndex:indexPath.row];
=======
        if ([fetchedArray count] >= 1) {
            [tableView beginUpdates];
            pub=[fetchedArray objectAtIndex:indexPath.row];
            pub.status=[[NSNumber alloc] initWithInt:0] ;
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [fetchedArray removeObjectAtIndex:[indexPath row]];
            NSLog(@"PUBLICACION: %@",pub);
            
            /*if ([fetchedArray count] == 0) {
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }*/
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Error al actualizar los datos: %@ %@", error, [error localizedDescription]);
            }
            [tableView endUpdates];
        }
    }
>>>>>>> master

}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    BUConsultaDetallePubVC *consultaDetallePub=[[BUConsultaDetallePubVC alloc]init];
    consultaDetallePub.publicacion=[fetchedArray objectAtIndex:indexPath.row];
    [self presentViewController:consultaDetallePub animated:YES completion:nil];
}

<<<<<<< HEAD
=======
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Desactivar";
}
>>>>>>> master

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end

